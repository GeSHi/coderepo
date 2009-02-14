*&---------------------------------------------------------------------*
*& Report  BCALV_TREE_DEMO                                             *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

report  bcalv_tree_demo.

class cl_gui_column_tree definition load.
class cl_gui_cfw definition load.

data tree1  type ref to cl_gui_alv_tree.
data mr_toolbar type ref to cl_gui_toolbar.

include <icon>.
include bcalv_toolbar_event_receiver.
include bcalv_tree_event_receiver.

data: toolbar_event_receiver type ref to lcl_toolbar_event_receiver.

data: gt_sflight      type sflight occurs 0,      "Output-Table
      gt_fieldcatalog type lvc_t_fcat, "Fieldcatalog
      ok_code like sy-ucomm.           "OK-Code

start-of-selection.

end-of-selection.

  call screen 100.

*&---------------------------------------------------------------------*
*&      Module  PBO  OUTPUT
*&---------------------------------------------------------------------*
*       process before output
*----------------------------------------------------------------------*
module pbo output.

  set pf-status 'MAIN100'.
  if tree1 is initial.
    perform init_tree.
  endif.
  call method cl_gui_cfw=>flush.
endmodule.                             " PBO  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PAI  INPUT
*&---------------------------------------------------------------------*
*       process after input
*----------------------------------------------------------------------*
module pai input.

  case ok_code.
    when 'EXIT' or 'BACK' or 'CANC'.
      perform exit_program.

    when others.
      call method cl_gui_cfw=>dispatch.
  endcase.
  clear ok_code.
  call method cl_gui_cfw=>flush.

endmodule.                             " PAI  INPUT

*&---------------------------------------------------------------------*
*&      Form  build_fieldcatalog
*&---------------------------------------------------------------------*
*       build fieldcatalog for structure sflight
*----------------------------------------------------------------------*
form build_fieldcatalog.

* get fieldcatalog
  call function 'LVC_FIELDCATALOG_MERGE'
    exporting
      i_structure_name = 'SFLIGHT'
    changing
      ct_fieldcat      = gt_fieldcatalog.

  sort gt_fieldcatalog by scrtext_l.

* change fieldcatalog
  data: ls_fieldcatalog type lvc_s_fcat.
  loop at gt_fieldcatalog into ls_fieldcatalog.
    case ls_fieldcatalog-fieldname.
      when 'CARRID' or 'CONNID' or 'FLDATE'.
        ls_fieldcatalog-no_out = 'X'.
        ls_fieldcatalog-key    = ''.
      when 'PRICE' or 'SEATSOCC' or 'SEATSMAX' or 'PAYMENTSUM'.
        ls_fieldcatalog-do_sum = 'X'.
    endcase.
    modify gt_fieldcatalog from ls_fieldcatalog.
  endloop.
endform.                               " build_fieldcatalog
*&---------------------------------------------------------------------*
*&      Form  build_hierarchy_header
*&---------------------------------------------------------------------*
*       build hierarchy-header-information
*----------------------------------------------------------------------*
*      -->P_L_HIERARCHY_HEADER  strucxture for hierarchy-header
*----------------------------------------------------------------------*
form build_hierarchy_header changing
                               p_hierarchy_header type treev_hhdr.

  p_hierarchy_header-heading = 'Hierarchy Header'.          "#EC NOTEXT
  p_hierarchy_header-tooltip =
                         'This is the Hierarchy Header !'.  "#EC NOTEXT
  p_hierarchy_header-width = 30.
  p_hierarchy_header-width_pix = ''.

endform.                               " build_hierarchy_header
*&---------------------------------------------------------------------*
*&      Form  exit_program
*&---------------------------------------------------------------------*
*       free object and leave program
*----------------------------------------------------------------------*
form exit_program.

  call method tree1->free.
  leave program.

endform.                               " exit_program
*&---------------------------------------------------------------------*
*&      Form  build_header
*&---------------------------------------------------------------------*
*       build table for html_header
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form build_comment using
      pt_list_commentary type slis_t_listheader
      p_logo             type sdydo_value.

  data: ls_line type slis_listheader.

*
* LIST HEADING LINE: TYPE H
  clear ls_line.
  ls_line-typ  = 'H'.

* LS_LINE-KEY:  NOT USED FOR THIS TYPE
  ls_line-info = 'ALV-tree-demo: flight-overview'.          "#EC NOTEXT
  append ls_line to pt_list_commentary.
* STATUS LINE: TYPE S
  clear ls_line.
  ls_line-typ  = 'S'.
  ls_line-key  = 'valid until'.                             "#EC NOTEXT
  ls_line-info = 'January 29 1999'.                         "#EC NOTEXT
  append ls_line to pt_list_commentary.
  ls_line-key  = 'time'.
  ls_line-info = '2.00 pm'.                                 "#EC NOTEXT
  append ls_line to pt_list_commentary.
* ACTION LINE: TYPE A
  clear ls_line.
  ls_line-typ  = 'A'.

* LS_LINE-KEY:  NOT USED FOR THIS TYPE
  ls_line-info = 'actual data'.                             "#EC NOTEXT
  append ls_line to pt_list_commentary.

  p_logo = 'ENJOYSAP_LOGO'.
endform.                    "build_comment
*&---------------------------------------------------------------------*
*&      Form  create_hierarchy
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form create_hierarchy.

  data: ls_sflight type sflight,
        lt_sflight type sflight occurs 0.

* get data
  select * from sflight into table lt_sflight
                        up to 200 rows .                "#EC CI_NOWHERE

  sort lt_sflight by carrid connid fldate.

* add data to tree
  data: l_carrid_key type lvc_nkey,
        l_connid_key type lvc_nkey,
        l_last_key type lvc_nkey.
  loop at lt_sflight into ls_sflight.
    on change of ls_sflight-carrid.
      perform add_carrid_line using    ls_sflight
                                       ''
                              changing l_carrid_key.
    endon.
    on change of ls_sflight-connid.
      perform add_connid_line using    ls_sflight
                                       l_carrid_key
                              changing l_connid_key.

    endon.
    perform add_complete_line using  ls_sflight
                                     l_connid_key
                            changing l_last_key.
  endloop.

* calculate totals
  call method tree1->update_calculations.

* this method must be called to send the data to the frontend
  call method tree1->frontend_update.

endform.                               " create_hierarchy

*&---------------------------------------------------------------------*
*&      Form  add_carrid_line
*&---------------------------------------------------------------------*
*       add hierarchy-level 1 to tree
*----------------------------------------------------------------------*
*      -->P_LS_SFLIGHT  sflight
*      -->P_RELEATKEY   relatkey
*     <-->p_node_key    new node-key
*----------------------------------------------------------------------*
form add_carrid_line using     ps_sflight type sflight
                               p_relat_key type lvc_nkey
                     changing  p_node_key type lvc_nkey.

  data: l_node_text type lvc_value,
        ls_sflight type sflight.

* set item-layout
  data: lt_item_layout type lvc_t_layi,
        ls_item_layout type lvc_s_layi.
  ls_item_layout-t_image = '@3P@'.
  ls_item_layout-fieldname = tree1->c_hierarchy_column_name.
  ls_item_layout-style   =
                        cl_gui_column_tree=>style_intensifd_critical.
  append ls_item_layout to lt_item_layout.

* add node
  l_node_text =  ps_sflight-carrid.

  data: ls_node type lvc_s_layn.
  ls_node-n_image   = space.
  ls_node-exp_image = space.

  call method tree1->add_node
    exporting
      i_relat_node_key = p_relat_key
      i_relationship   = cl_gui_column_tree=>relat_last_child
      i_node_text      = l_node_text
      is_outtab_line   = ls_sflight
      is_node_layout   = ls_node
      it_item_layout   = lt_item_layout
    importing
      e_new_node_key   = p_node_key.

endform.                               " add_carrid_line
*&---------------------------------------------------------------------*
*&      Form  add_connid_line
*&---------------------------------------------------------------------*
*       add hierarchy-level 2 to tree
*----------------------------------------------------------------------*
*      -->P_LS_SFLIGHT  sflight
*      -->P_RELEATKEY   relatkey
*     <-->p_node_key    new node-key
*----------------------------------------------------------------------*
form add_connid_line using     ps_sflight type sflight
                               p_relat_key type lvc_nkey
                     changing  p_node_key type lvc_nkey.

  data: l_node_text type lvc_value,
        ls_sflight type sflight.

* set item-layout
  data: lt_item_layout type lvc_t_layi,
        ls_item_layout type lvc_s_layi.
  ls_item_layout-t_image = '@3Y@'.
  ls_item_layout-style   =
                        cl_gui_column_tree=>style_intensified.
  ls_item_layout-fieldname = tree1->c_hierarchy_column_name.
  append ls_item_layout to lt_item_layout.

* add node
  l_node_text =  ps_sflight-connid.
  data: relat type int4.
  relat = cl_gui_column_tree=>relat_last_child.
  call method tree1->add_node
    exporting
      i_relat_node_key = p_relat_key
      i_relationship   = relat
      i_node_text      = l_node_text
      is_outtab_line   = ls_sflight
      it_item_layout   = lt_item_layout
    importing
      e_new_node_key   = p_node_key.

endform.                               " add_connid_line
*&---------------------------------------------------------------------*
*&      Form  add_cmplete_line
*&---------------------------------------------------------------------*
*       add hierarchy-level 3 to tree
*----------------------------------------------------------------------*
*      -->P_LS_SFLIGHT  sflight
*      -->P_RELEATKEY   relatkey
*     <-->p_node_key    new node-key
*----------------------------------------------------------------------*
form add_complete_line using   ps_sflight type sflight
                               p_relat_key type lvc_nkey
                     changing  p_node_key type lvc_nkey.

  data: l_node_text type lvc_value.

* set item-layout
  data: lt_item_layout type lvc_t_layi,
        ls_item_layout type lvc_s_layi.
  ls_item_layout-fieldname = tree1->c_hierarchy_column_name.
  ls_item_layout-class   = cl_gui_column_tree=>item_class_checkbox.
  ls_item_layout-editable = 'X'.
  append ls_item_layout to lt_item_layout.

  clear ls_item_layout.
  ls_item_layout-fieldname = 'PLANETYPE'.
  ls_item_layout-alignment = cl_gui_column_tree=>align_right.
  append ls_item_layout to lt_item_layout.

  l_node_text =  ps_sflight-fldate.

  data: ls_node type lvc_s_layn.
  ls_node-n_image   = space.
  ls_node-exp_image = space.

  call method tree1->add_node
    exporting
      i_relat_node_key = p_relat_key
      i_relationship   = cl_gui_column_tree=>relat_last_child
      is_outtab_line   = ps_sflight
      i_node_text      = l_node_text
      is_node_layout   = ls_node
      it_item_layout   = lt_item_layout
    importing
      e_new_node_key   = p_node_key.
endform.                               " add_complete_line
*&---------------------------------------------------------------------*
*&      Form  register_events
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form register_events.
* define the events which will be passed to the backend
  data: lt_events type cntl_simple_events,
        l_event type cntl_simple_event.

* define the events which will be passed to the backend
  l_event-eventid = cl_gui_column_tree=>eventid_expand_no_children.
  append l_event to lt_events.
  l_event-eventid = cl_gui_column_tree=>eventid_checkbox_change.
  append l_event to lt_events.
  l_event-eventid = cl_gui_column_tree=>eventid_header_context_men_req.
  append l_event to lt_events.
  l_event-eventid = cl_gui_column_tree=>eventid_node_context_menu_req.
  append l_event to lt_events.
  l_event-eventid = cl_gui_column_tree=>eventid_item_context_menu_req.
  append l_event to lt_events.
  l_event-eventid = cl_gui_column_tree=>eventid_header_click.
  append l_event to lt_events.
  l_event-eventid = cl_gui_column_tree=>eventid_item_keypress.
  append l_event to lt_events.

  call method tree1->set_registered_events
    exporting
      events                    = lt_events
    exceptions
      cntl_error                = 1
      cntl_system_error         = 2
      illegal_event_combination = 3.
  if sy-subrc <> 0.
    message x208(00) with 'ERROR'.                          "#EC NOTEXT
  endif.



* set Handler
  data: l_event_receiver type ref to lcl_tree_event_receiver.
  create object l_event_receiver.
  set handler l_event_receiver->handle_node_ctmenu_request
                                                        for tree1.
  set handler l_event_receiver->handle_node_ctmenu_selected
                                                        for tree1.
  set handler l_event_receiver->handle_item_ctmenu_request
                                                        for tree1.
  set handler l_event_receiver->handle_item_ctmenu_selected
                                                        for tree1.
endform.                               " register_events
*&---------------------------------------------------------------------*
*&      Form  change_toolbar
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form change_toolbar.

* get toolbar control
  call method tree1->get_toolbar_object
    importing
      er_toolbar = mr_toolbar.

  check not mr_toolbar is initial.

* add seperator to toolbar
  call method mr_toolbar->add_button
    exporting
      fcode     = ''
      icon      = ''
      butn_type = cntb_btype_sep
      text      = ''
      quickinfo = 'This is a Seperator'.                    "#EC NOTEXT

* add Standard Button to toolbar (for Delete Subtree)
  call method mr_toolbar->add_button
    exporting
      fcode     = 'DELETE'
      icon      = '@18@'
      butn_type = cntb_btype_button
      text      = ''
      quickinfo = 'Delete subtree'.                         "#EC NOTEXT

* add Dropdown Button to toolbar (for Insert Line)
  call method mr_toolbar->add_button
    exporting
      fcode     = 'INSERT_LC'
      icon      = '@17@'
      butn_type = cntb_btype_dropdown
      text      = ''
      quickinfo = 'Insert Line'.                            "#EC NOTEXT

* set event-handler for toolbar-control
  create object toolbar_event_receiver.
  set handler toolbar_event_receiver->on_function_selected
                                                      for mr_toolbar.
  set handler toolbar_event_receiver->on_toolbar_dropdown
                                                      for mr_toolbar.

endform.                               " change_toolbar
*&---------------------------------------------------------------------*
*&      Form  init_tree
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form init_tree.

* create fieldcatalog for structure sflight
  perform build_fieldcatalog.

* create container for alv-tree
  data: l_tree_container_name(30) type c,
        l_custom_container type ref to cl_gui_custom_container.
  l_tree_container_name = 'TREE1'.

  if sy-batch is initial.
    create object l_custom_container
      exporting
            container_name = l_tree_container_name
      exceptions
            cntl_error                  = 1
            cntl_system_error           = 2
            create_error                = 3
            lifetime_error              = 4
            lifetime_dynpro_dynpro_link = 5.
    if sy-subrc <> 0.
      message x208(00) with 'ERROR'.                        "#EC NOTEXT
    endif.
  endif.

* create tree control
  create object tree1
    exporting
        parent              = l_custom_container
        node_selection_mode = cl_gui_column_tree=>node_sel_mode_multiple
        item_selection      = SPACE
        no_html_header      = ''
        no_toolbar          = ''
    exceptions
        cntl_error                   = 1
        cntl_system_error            = 2
        create_error                 = 3
        lifetime_error               = 4
        illegal_node_selection_mode  = 5
        failed                       = 6
        illegal_column_name          = 7.
  if sy-subrc <> 0.
    message x208(00) with 'ERROR'.                          "#EC NOTEXT
  endif.

* create Hierarchy-header
  data l_hierarchy_header type treev_hhdr.
  perform build_hierarchy_header changing l_hierarchy_header.

* create info-table for html-header
  data: lt_list_commentary type slis_t_listheader,
        l_logo             type sdydo_value.
  perform build_comment using
                 lt_list_commentary
                 l_logo.

* repid for saving variants
  data: ls_variant type disvariant.
  ls_variant-report = sy-repid.

* create emty tree-control
  call method tree1->set_table_for_first_display
    exporting
      is_hierarchy_header = l_hierarchy_header
      it_list_commentary  = lt_list_commentary
      i_logo              = l_logo
      i_background_id     = 'ALV_BACKGROUND'
      i_save              = 'A'
      is_variant          = ls_variant
    changing
      it_outtab           = gt_sflight "table must be emty !!
      it_fieldcatalog     = gt_fieldcatalog.

* create hierarchy
  perform create_hierarchy.

* add own functioncodes to the toolbar
  perform change_toolbar.

* register events
*  perform register_events.

* adjust column_width
* call method tree1->COLUMN_OPTIMIZE.

endform.                    " init_tree
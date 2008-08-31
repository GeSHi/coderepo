#define mouse_over
////////////////////////////////////////////////
//
//  returns wether the mouse is over the
//  bounding box of the instance given in argument0
//  default value for argument0 is self
//
////////////////////////////////////////////////
var a;
if argument0 == 0 argument0 = self
argument0 = argument0.id
a = (mouse_x>=argument0.bbox_left)&&(mouse_x<=argument0.bbox_right)&&
    (mouse_y>=argument0.bbox_top)&&(mouse_y<=argument0.bbox_bottom)
return a

#define get_inst_num
////////////////////////////////////////////////
//
//  returns the place of the instance(argument0)
//  in the list of objects used for
//  instance_find(obj,n) -> n is returned
//
////////////////////////////////////////////////
if argument0 == 0 argument0 = self
for (i=0; i<instance_number(argument0.object_index);i+=1) {
  ii = instance_find(argument0.object_index,i)
  if ii.id==argument0.id {
    return i
  }
}
return -1

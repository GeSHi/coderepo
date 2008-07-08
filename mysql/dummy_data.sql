INSERT INTO kb_entries (entry_id, description, title, source_type, source_values, date_added, date_modified, selected_tags, tags) VALUES
  (
    1,
    'Nunc condimentum facilisis urna. Fusce varius suscipit nibh. Suspendisse potenti. Nunc vel ante sit amet enim auctor interdum. Fusce tincidunt commodo nunc.',
    'Foo Bar ein Test',
    'web',
    'link:http://example.com',
    NOW(),
    NULL,
    '4,6,10',
    '1,2,3,4,6,7,10'
  );
/********
  testing multiline comments
  SELECT foo FROM bar
 *********/
 
-- single line comment
 
INSERT INTO kb_entry_links (entry_id, link) VALUES
  (1, 'http://example.com'),
  (1, 'http://systematrix.de'),
  (1, 'http://google.de'),
  (1, 'http://php.net'),
  (1, 'office@systematrix.de');


INSERT INTO kb_tags (tag_id, tag, parent_id, depth, parents, owners) VALUES
  (1, 'B', 0, 0, '', '1'),
  (2, '1.1', 1, 1, '1', '1'),
  (3, '1.2', 1, 1, '1', '1'),
  (4, '1.2.1', 3, 2, '1,3', '1'),
  (5, '1.3', 1, 1, '1', '1'),
  (6, 'C', 0, 0, '', '1'),
  (7, 'A', 0, 0, '', '1'),
  (8, '3.1', 7, 1, '7', '1'),
  (9, '3.1.1', 8, 2, '7,8', '1'),
  (10, '3.2', 7, 1, '7', '1');

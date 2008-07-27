CREATE TABLE field_info (
  uid                         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  rsf                         TINYINT(3) DEFAULT 1,
  descriptor                  VARCHAR(40),        # The fieldname
  Table_uid                   BIGINT UNSIGNED,
  Alias                       VARCHAR(40) NULL,   # An alternate name to use
  Field_type_uid              BIGINT UNSIGNED,    # Mapping of SQL to Perl types
  Nullify                     ENUM('Y', 'N'),
  Is_key                      ENUM('N', 'PRI'),
  Validation_regexp           TINYTEXT,
  Calculation                 TINYTEXT,
  Default_value               TINYTEXT,
  Description                 TINYTEXT,
  Prompt                      TINYTEXT,           # Explanation of what to enter
  Resource_uid                INT,
  PRIMARY KEY (uid)
);

DELETE FROM user WHERE uid=999;
INSERT INTO user (
    uid, descriptor, Real_email, Given_name, Surname, Userpassword
) VALUES (
    999, 'test', 'test@noplace.org', 'Test', 'Tester', '098f6bcd4621d373cade4e832627b4f6'
);


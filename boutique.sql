ALTER TABLE `users` ADD  `pb` int(11) NOT NULL DEFAULT 0;
ALTER TABLE `users` ADD  `boutique_id` int(11) NOT NULL;

INSERT INTO `items` (`name`, `label`) VALUES ('gold_case', 'Caisse Gold');
INSERT INTO `items` (`name`, `label`) VALUES ('ruby_case', 'Caisse Ruby');
INSERT INTO `items` (`name`, `label`) VALUES ('diamond_case', 'Caisse Diamond');
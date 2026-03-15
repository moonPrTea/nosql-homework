-- Решение заданий по Scylla
create keyspace homework_ks
    WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

use homework_ks;

create table users_with_posts (
	post_id int,
	user_id int,
	username text,
	content text,
	created_at TIMESTAMP,
	PRIMARY KEY (user_id, created_at, post_id)
) with clustering order by (created_at desc, post_id asc);

insert into users_with_posts (post_id, user_id, username, content, created_at) values (1, 1, 'moon', 'some content for example', '2025-12-04 06:00:10');
insert into users_with_posts (post_id, user_id, username, content, created_at) values (2, 2, 'mick programmer', 'some content for example', '2026-01-09 01:00:00');
insert into users_with_posts (post_id, user_id, username, content, created_at) values (3, 3, 'mark123', 'some content for example', '2026-01-12 01:00:00');
insert into users_with_posts (post_id, user_id, username, content, created_at) values (4, 1, 'moon', 'some content for example', '2026-02-12 10:01:11');
insert into users_with_posts (post_id, user_id, username, content, created_at) values (5, 4, 'spring1323', 'some content for example', '2026-02-22 16:08:12');
insert into users_with_posts (post_id, user_id, username, content, created_at) values (6, 5, 'michael2000', 'some content for example', '2026-03-03 17:14:13');
insert into users_with_posts (post_id, user_id, username, content, created_at) values (7, 2, 'mick programmer', 'some content for example', '2026-03-04 14:13:01');
insert into users_with_posts (post_id, user_id, username, content, created_at) values (8, 6, 'peter parker', 'some content for example', '2026-03-05 12:13:11');
insert into users_with_posts (post_id, user_id, username, content, created_at) values (9, 6, 'peter parker', 'some content for example', '2026-03-12 09:22:44');
insert into users_with_posts (post_id, user_id, username, content, created_at) values (10, 5, 'michael2000', 'some content for example', '2025-03-12 13:40:13');
insert into users_with_posts (post_id, user_id, username, content, created_at) values (11, 6, 'peter parker', 'some content for example', '2026-03-12 19:43:12');

-- 1. Запрос, который достает посты заданного пользователя, упорядоченные по времени создания поста (сначала новые).
select post_id, content, created_at
from users_with_posts
where user_id = 1;

-- 2. Запрос, который достает последний пост заданного пользователя
select post_id, content, created_at, username
from users_with_posts
where user_id = 1
limit 1;

-- 3. Запрос, который достает посты заданного пользователя после заданной даты
select post_id, content, created_at
from users_with_posts
where user_id = 6 and created_at > '2026-03-06';

-- Создание таблицы для выполнения запроса задания 4
create table posts_with_day_topic (
	post_id int,
	user_id int,
	username text,
	topic_id int,
	created_date date,
	created_at TIMESTAMP,
	PRIMARY KEY ((created_date, topic_id), created_at, post_id)
) with clustering order by (created_at desc);

insert into posts_with_day_topic (post_id, user_id, username, topic_id, created_date, created_at) values (4, 1, 'moon', 8, '2026-02-12', '2026-02-12 10:01:11');
insert into posts_with_day_topic (post_id, user_id, username, topic_id, created_date, created_at) values (5, 4, 'spring1323', 2, '2026-02-22', '2026-02-22 16:08:12');
insert into posts_with_day_topic (post_id, user_id, username, topic_id, created_date, created_at) values (6, 5, 'michael2000', 5, '2026-03-03', '2026-03-03 17:14:13');
insert into posts_with_day_topic (post_id, user_id, username, topic_id, created_date, created_at) values (7, 2, 'mick programmer', 8, '2026-03-04', '2026-03-04 14:13:01');
insert into posts_with_day_topic (post_id, user_id, username, topic_id, created_date, created_at) values (8, 6, 'peter parker', 7, '2026-03-05', '2026-03-05 12:13:11');
insert into posts_with_day_topic (post_id, user_id, username, topic_id, created_date, created_at) values (9, 6, 'peter parker', 4, '2026-03-12', '2026-03-12 09:22:44');
insert into posts_with_day_topic (post_id, user_id, username, topic_id, created_date, created_at) values (10, 5, 'michael2000', 9, '2026-03-12', '2026-03-12 13:40:13');
insert into posts_with_day_topic (post_id, user_id, username, topic_id, created_date, created_at) values (11, 6, 'peter parker', 9, '2026-03-12', '2026-03-12 19:43:12');

-- 4. Запрос, который достает пользователей, сделавших пост в заданный день по заданной теме, упорядоченные по времени (сначала новые)
select user_id, username, post_id, created_at
from posts_with_day_topic
where topic_id = 9 and created_date = '2026-03-12';


-- Решение заданий по ClickHouse

-- 1. Создание таблицы
CREATE TABLE IF NOT EXISTS server_logs
(
    user_id UInt32,
    endpoint String,
    response_time_ms UInt32,
    status_code UInt16,
    timestamp DateTime('UTC')
)
ENGINE = MergeTree()
ORDER BY (endpoint, timestamp, status_code);

-- 2. Загрузка данных из CSV
-- Подсказка: можно использовать clickhouse-client с параметром --query
-- Пример команды (выполняется в терминале):
-- cat server_logs.csv | clickhouse-client --query="INSERT INTO server_logs FORMAT CSVWithNames"


-- 3. Запрос: Топ-5 самых медленных endpoint'ов (по среднему времени ответа)
select endpoint, avg(response_time_ms) as avg_time_ms
from server_logs
group by endpoint
order by avg(response_time_ms) desc
limit 5;

-- 4. Запрос: Количество запросов по часам за весь период в логах
select count(*) as count_requests, formatDateTime(timestamp, '%H') as hour
from server_logs
group by hour
order by hour;


-- 5. Запрос: Процент ошибок (status_code >= 400) для каждого endpoint'а
select endpoint,
countIf(status_code >= 400) / count() * 100 as errors_percent
from server_logs
group by endpoint
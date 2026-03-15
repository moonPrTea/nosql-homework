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
ORDER BY (timestamp, endpoint);

-- 2. Загрузка данных из CSV
-- Подсказка: можно использовать clickhouse-client с параметром --query
-- Пример команды (выполняется в терминале):
-- cat server_logs.csv | clickhouse-client --query="INSERT INTO server_logs FORMAT CSVWithNames"


-- 3. Запрос: Топ-5 самых медленных endpoint'ов (по среднему времени ответа)
select endpoint, round(avg(response_time_ms), 2) as avg_time_ms
from server_logs
group by endpoint
order by avg(response_time_ms) desc
limit 5;

-- 4. Запрос: Количество запросов по часам за весь период в логах
select formatDateTime(timestamp, '%H') as hour, count(*) as count_requests
from server_logs
group by hour
order by hour;


-- 5. Запрос: Процент ошибок (status_code >= 400) для каждого endpoint'а
select endpoint,
round(countIf(status_code >= 400) / count() * 100, 2) as errors_percent
from server_logs
group by endpoint

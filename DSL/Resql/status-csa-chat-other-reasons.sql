SELECT date_trunc(:metric, created) AS date_time,
       COUNT(DISTINCT base_id)
FROM chat
WHERE EXISTS
    (SELECT 1
     FROM message
     WHERE message.chat_base_id = chat.base_id
       AND message.author_role = 'backoffice-user')
  AND EXISTS
    (SELECT 1
     FROM message
     WHERE message.chat_base_id = chat.base_id
       AND message.author_role = 'end-user')
  AND EXISTS
    (SELECT 1
     FROM message
     WHERE message.chat_base_id = chat.base_id
       AND message.event = 'terminated')     
  AND status = 'ENDED'
  AND feedback_rating IS NOT NULL
  AND created::date BETWEEN :start::date AND :end::date
GROUP BY 1

SELECT '#' || tag as tag,
             count(*) AS count
 FROM (
             select distinct data->>'id',
                                    jsonb_path_query(data, '$.extended_tweet.entities.hashtags[*]')->>'text' as tag
             from tweets_jsonb
             where (
                        to_tsvector('english',data->>'text')@@to_tsquery('english','coronavirus')
                       or to_tsvector('english',data->'extended_tweet'->>'full_text')@@to_tsquery('english','coronavirus')
                       )
                       and data->>'lang'='en'
            UNION
            select distinct data->>'id',
                                            jsonb_path_query(data,'$.entities.hashtags[*]')->>'text' as tag
             from tweets_jsonb
            where (
                       to_tsvector('english',data->>'text')@@to_tsquery('english','coronavirus')
                       or to_tsvector('english',data->'extended_tweet'->>'full_text')@@to_tsquery('english','coronavirus')
                      )
                     and data->>'lang'='en'
)t
GROUP BY tag
ORDER BY count DESC, tag
limit 1000;

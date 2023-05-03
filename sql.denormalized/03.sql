
 

SELECT t.lang, 
     count(*) as count
FROM (
     select distinct data->>'id',
                     data->>'lang' as lang
     from tweets_jsonb
     where data ->'extended_tweet'->'entities'->'hashtags'@@'$[*].text == "coronavirus"'
       union 
     select distinct data->>'id',
            data->>'lang' as lang
     from tweets_jsonb
     where  data->'entities'->'hashtags'@@'$[*].text == "coronavirus"'
)t
group by lang
order by count desc, lang
;

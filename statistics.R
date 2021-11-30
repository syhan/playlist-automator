library(DBI)
library(ggplot2)

setwd("/Users/i063815/Workspace/syhan/playlist-automator")
con <- dbConnect(RSQLite::SQLite(), "./stats.db")

topContributors <- dbGetQuery(
  con,
  '
SELECT * FROM (
  SELECT b.NAME, COUNT(*) AS TOTAL FROM contributions AS a
  INNER JOIN contributors AS b
  ON a.UID = b.UID
  GROUP BY b.UID, b.NAME
  ORDER BY COUNT(*) DESC
) LIMIT 10'
)

ggplot(data = topContributors,
       mapping = aes(
         x = NAME,
         y = TOTAL,
       )) +
  guides(fill = "none") +
  geom_col() +
  labs(x = NULL,
       y = "贡献数") +
  theme(text = element_text(family = 'STXihei'),
        axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) 

library(dplyr)

dailyContrib <- tbl(con, "contributions") %>%
  group_by(DAY) %>%
  summarise(daily = count(TRACK_ID)) 

ggplot(dailyContrib, aes(x = as.Date(DAY), y = daily, size = daily)) +
  geom_point(alpha = .5, fill = "cornflowerblue", color = "black", shape = 21) +
  scale_size_continuous(range = c(1, 14)) +
  geom_smooth(method = "loess") + 
  guides(size = "none") +
  labs(x = NULL, y = "歌曲数") +
  theme(text = element_text(family = 'STXihei'))

library(wordcloud2) 

artists <- tbl(con, "contributions") %>%
  inner_join(tbl(con, "tracks"), "TRACK_ID") %>%
  group_by(ARTIST) %>%
  summarise(hits = count(ARTIST)) %>%
  arrange(desc(hits))

wordcloud2(data=artists, size=1.6, color='skyblue', backgroundColor="black", minRotation = -pi/6, maxRotation = -pi/6, rotateRatio = 1)

library(treemap)

contributors <- tbl(con, "contributors") %>%
  inner_join(tbl(con, "contributions"), "UID") %>%
  group_by(name) %>%
  summarise(count = count(name)) %>%
  as.data.frame()

print(contributors)

treemap(contributors, index = "name", vSize = "count", type="index", fontfamily.labels = "STXihei")

dbDisconnect(con)
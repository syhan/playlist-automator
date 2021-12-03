library(DBI)
library(ggplot2)
library(RSQLite)

setwd("~/Workspace/syhan/playlist-automator")
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
  theme(text = element_text(family = 'STHeiti'),
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
  theme(text = element_text(family = 'STHeiti'))

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
  show_query() %>%
  as.data.frame()

treemap(contributors, index = "name", vSize = "count", type="index", fontfamily.labels = "STHeiti")

library(networkD3)

contribArtist <- dbGetQuery(
  con,
  '
SELECT * FROM (
  SELECT b.NAME, c.ARTIST, COUNT(a.TRACK_ID) AS TOTAL FROM contributions AS a
  INNER JOIN contributors AS b
  ON a.UID = b.UID
  INNER JOIN tracks AS c
  ON a.TRACK_ID = c.TRACK_ID
  GROUP BY b.NAME, c.ARTIST
  ORDER BY b.NAME, COUNT(a.TRACK_ID), c.ARTIST DESC
) WHERE TOTAL > 2'
)

nodes <- data.frame(name=c(as.character(contribArtist$NAME), as.character(contribArtist$ARTIST)) %>% unique())
contribArtist$IDsource=match(contribArtist$NAME, nodes$name)-1 
contribArtist$IDtarget=match(contribArtist$ARTIST, nodes$name)-1

sankeyNetwork(Links = contribArtist, Nodes = nodes,
              Source = "IDsource", Target = "IDtarget",
              Value = "TOTAL", NodeID = "name", 
              sinksRight=FALSE, fontFamily = "STHeiti")

dbDisconnect(con)
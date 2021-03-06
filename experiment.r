dc_sld <- read.dbf("data/SmartLocationDb.dbf") %>%
  filter(SFIPS == 11)

dc_sld <- dc_sld %>%
  mutate(id = GEOID10)

dc_bg <- block_groups("DC")
dc_bg_fortify <- dc_bg %>%
  fortify(region = 'GEOID')

dc_merged <- left_join(dc_bg_fortify, dc_sld, by = "id")

dc_stamen12 <- get_map(location = "Washington DC", zoom = 12, maptype = "toner")
dc_stamen11 <- get_map(location = c(-77.14, 38.78, -76.90, 39.00), zoom = 11, maptype = "toner")
dc_stamen12 <- get_map(location = c(-77.14, 38.78, -76.90, 39.00), zoom = 12, maptype = "toner")
dc_stamen12wc <- get_map(location = c(-77.14, 38.78, -76.90, 39.00), zoom = 12, maptype = "watercolor")
dc_stamen13 <- get_map(location = c(-77.14, 38.78, -76.90, 39.00), zoom = 13, maptype = "toner")

ggmap(dc_stamen12, extent = "panel") +
  geom_polygon(data = dc_merged, aes(x = long, y = lat, group = group,
                                    fill = D5ar), size = .2,
               alpha = .4) +
  scale_fill_viridis(option = "plasma",
                     limits = c(0, max(dc_merged$D5ar)),
                     breaks = seq(0, max(dc_merged$D5ar), 100000),
                     labels = comma) +
  geom_polygon(data = dc_merged, aes(x = long, y = lat, group = group,
                                     color = D5ar), fill = NA, size = .3,
               alpha = 1, show.legend = FALSE) +
  scale_color_viridis(option = "plasma",
                     limits = c(0, max(dc_merged$D5ar))) +
  scale_x_continuous(limits = c(-77.14, -76.90)) +
  scale_y_continuous(limits = c(38.78, 39.00)) +
  labs(title = "Jobs Accessible in a 45-Minute Drive",
       fill = "Jobs",
       caption = "Source: EPA Smart Location Database") +
  theme_sbmap +
  theme(plot.title = element_text(size = 10, hjust = .1,
                                  margin = margin(b = -10)),
        plot.caption = element_text(margin = margin(t = -14),
                                    hjust = .92),
        plot.margin = unit(c(.1, .3, .1, -.1), "in"),
        legend.margin = margin(0),
        legend.box.background = element_rect(fill = "white", color = NA),
        legend.box.margin = unit(c(.1, .1, .1, 0), "in"),
        legend.position = c(1, .2)
        )

ggsave(file = "~/Pictures/toner accessibility.jpg", width = 5, height = 5)

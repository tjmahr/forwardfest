# forwardfest

This repository contains my portion of a group talk about reproducible 
research. I talked about RMarkdown and demoed some of the basic ideas.

`talk.Rmd` is the source of the slides. Each of the `demo*.Rmd` files 
is an RMarkdown demo. Here are what the output look like in general.
(That is, if the RawGit service is working... I had trouble when I 
first uploaded the slides.)

* [Slides](https://cdn.rawgit.com/tjmahr/forwardfest/f114796c/rendered/talk.html)
* [Demo 4 output](https://cdn.rawgit.com/tjmahr/forwardfest/f114796c/rendered/demo4.html)

`get_data.R` is an R script for scraping IMDB ratings for TV shows. 
I used to generate the datasets of TV episode ratings.

* `got_avgs.csv` - _Game of Thrones_
* `pnr_avgs.csv` - _Parks and Recreation_
* `simp_avgs.csv` - _The Simpsons_

The analysis code and document in the RMarkdown documents is modular enough 
to handle these different datasets. This demonstrates how the same report
can be dynamically update when the dataset changes.


```r
# Render the slides
rmarkdown::render("./talk.Rmd", output_dir = "./rendered")
```

```r
# How to do each demo from code (and not the knit button)
rmarkdown::render("./demo1.Rmd", output_dir = "./rendered")
rmarkdown::render("./demo2.Rmd", output_dir = "./rendered")

# Multiple formats
rmarkdown::render("./demo3.Rmd", output_dir = "./rendered", 
                   output_format = "all")

# Different dataset
rmarkdown::render("./demo4.Rmd", output_dir = "./rendered")

# Dataset specified by parameter
rmarkdown::render("./demo4.Rmd", output_dir = "./rendered", 
                  params = list(filename = "./simp_avgs.csv"))
```

To run the interactive demo. Still a little wonky.

```r
rmarkdown::run("./demo5.Rmd")
```

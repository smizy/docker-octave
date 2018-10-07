# docker-octave

Octave + Jupyter Notebook docker image based on alpine

```
# run jupyter
docker run -it --rm -p 8888:8888 -v $PWD:/code  smizy/octave:4.2.0-r2-alpine

# open browser (see token in log)
open http://$(docker-machine ip default):8888?token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# create a notebook selecting "Octave" from [New] pulldown  

# run cell
x = rand(10,1)
plot(x)

```
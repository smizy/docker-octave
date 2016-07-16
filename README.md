# docker-octave

Octave + Jupyter Notebook docker image based on alpine

```
# run jupyter
docker run  -p 8888:8888 -v $(pwd):/code  -d smizy/octave:4.0.3-jupyter-alpine

# open browser
open http://$(docker-machine ip default):8888

# create a notebook selecting "Octave" from [New] pulldown  

# run cell
x = rand(10,1)
plot(x)

```
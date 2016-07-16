# docker-octave

Octave + Jupyter Notebook docker image based on alpine

```
docker run  -p 8888:8888 -v $(pwd):/code  -d smizy/octave:4.0.3-jupyter-alpine
```
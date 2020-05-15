# About

pluginsDownloader - tool for fresh install plugins TeamCity Server in AWS ECS. 

# Environment variables
| Variable | Type | Description |
| -------- | ------- | ---- |
| PLUGINS_DIR | string | TeamCity Plugins directory
| PLUGINS_LIST | json | TeamCity Plugins list |

# Plugins list format
```
[
  {
    "name": "aws-ecs",
    "url": "https://....zip"
  }
]
```

# Example
```
export PLUGINS_DIR=/data/plugins
export PLUGINS_LIST="[{\\\"name\\\":\\\"aws-ecs\\\",\\\"url\\\":\\\"https://plugins.jetbrains.com/files/10067/76713/aws-ecs.zip\\\"}]"
```



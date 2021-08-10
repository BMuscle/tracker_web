# README


## 環境構築

### InfluxDBのセットアップ

Influx DBへアクセスするにはトークンが必要。
開発環境や、テスト環境ではADMINのトークンでも良い。

read, writeが可能なトークンを作るには以下のコマンドを実行する。

```bash
docker-compose exec influx_db bash -c 'influx auth create --org $DOCKER_INFLUXDB_INIT_ORG  --write-buckets $DOCKER_INFLUXDB_INIT_BUCKET --read-buckets $DOCKER_INFLUXDB_INIT_BUCKET' | tail -n 1 | awk '{print $2}'
```

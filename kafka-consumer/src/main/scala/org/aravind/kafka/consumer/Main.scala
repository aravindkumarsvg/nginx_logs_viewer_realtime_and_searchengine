package org.aravind.kafka.consumer

import java.util
import org.apache.kafka.clients.consumer.KafkaConsumer
import java.util.Properties
import scala.collection.JavaConverters._
import play.api.libs.json._
import org.mongodb.scala._
import scala.concurrent.Await
import scala.concurrent.duration.Duration
import java.util.concurrent.TimeUnit


object Main extends App {
  val props = new Properties()
  props.put("bootstrap.servers", sys.env("KAFKA_BROKER"))
  props.put("key.deserializer", "org.apache.kafka.common.serialization.StringDeserializer")
  props.put("value.deserializer", "org.apache.kafka.common.serialization.StringDeserializer")
  props.put("auto.offset.reset", "latest")
  props.put("group.id", sys.env("KAFKA_CONSUMER_GROUP"))
  val consumer: KafkaConsumer[String, String] = new KafkaConsumer[String, String](props)
  consumer.subscribe(util.Arrays.asList(sys.env("KAFKA_TOPIC")))

  val mongoClient: MongoClient = MongoClient(sys.env("MONGODB_HOST"))
  val database: MongoDatabase = mongoClient.getDatabase(sys.env("MONGODB_DB"))
  val collection: MongoCollection[Document] = database.getCollection(sys.env("MONGODB_COLLECTION"))

  while (true) {
    val record = consumer.poll(1000).asScala
    for (data <- record.iterator) {
      val jsonObj : JsValue = Json.parse(data.value())
      val doc: Document = Document("request" -> (jsonObj \ "request").as[String], 
                                    "timestamp" -> (((jsonObj \ "timestamp").as[String]).split("\\.")(0)).toInt,
                                    "status" -> (jsonObj \ "status").as[String], 
      )
      val observable = collection.insertOne(doc)
      Await.result(observable.toFuture(), Duration(10, TimeUnit.SECONDS))
    }
  }
}
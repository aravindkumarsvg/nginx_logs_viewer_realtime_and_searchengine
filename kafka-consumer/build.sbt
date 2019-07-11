lazy val root = (project in file(".")).

  settings(
    inThisBuild(List(
      organization := "org.aravind.kafka",
      scalaVersion := "2.12.8"
    )),
    name := "consumer",
    version := "1.0.0",

    mainClass in assembly := Some("org.aravind.kafka.consumer.Main"),

    javacOptions ++= Seq("-source", "1.8", "-target", "1.8"),
    javaOptions ++= Seq("-Xms512M", "-Xmx2048M", "-XX:MaxPermSize=2048M", "-XX:+CMSClassUnloadingEnabled"),
    scalacOptions ++= Seq("-deprecation", "-unchecked"),

    libraryDependencies ++= Seq(
      "org.apache.kafka" %% "kafka" % "2.1.0",
      "com.typesafe.play" %% "play-json" % "2.6.8",
      "org.mongodb.scala" %% "mongo-scala-driver" % "2.6.0",
    ),

    // uses compile classpath for the run task, including "provided" jar (cf http://stackoverflow.com/a/21803413/3827)
    run in Compile := Defaults.runTask(fullClasspath in Compile, mainClass in (Compile, run), runner in (Compile, run)).evaluated,

    scalacOptions ++= Seq("-deprecation", "-unchecked"),
    pomIncludeRepository := { x => false },

   resolvers ++= Seq(
      "sonatype-releases" at "https://oss.sonatype.org/content/repositories/releases/",
      "Typesafe repository" at "http://repo.typesafe.com/typesafe/releases/",
      "Second Typesafe repo" at "http://repo.typesafe.com/typesafe/maven-releases/",
      Resolver.sonatypeRepo("public")
    ),

    pomIncludeRepository := { x => false },
  )

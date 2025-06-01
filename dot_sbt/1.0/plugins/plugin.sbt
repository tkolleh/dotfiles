resolvers += Resolver.sonatypeRepo("snapshots")
resolvers += Resolver.mavenLocal

// BSP related
addSbtPlugin("ch.epfl.scala" % "sbt-bloop" % "2.+")
addSbtPlugin("ch.epfl.scala" % "sbt-debug-adapter" % "4.+")
addSbtPlugin("com.github.sbt" % "sbt-jdi-tools" % "1.+")
addSbtPlugin("org.scala-debugger" % "sbt-jdi-tools" % "1.+")

//formatting
addSbtPlugin("org.scalameta" % "sbt-scalafmt" % "2.5.+")
addSbtPlugin("com.lightbend.sbt" % "sbt-java-formatter" % "0.+")
addSbtPlugin("ch.epfl.scala" % "sbt-scalafix" % "0.+")

//building
addSbtPlugin("com.eed3si9n" % "sbt-assembly" % "2.+")

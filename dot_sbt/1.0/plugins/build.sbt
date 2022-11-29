/* libraryDependencies += "org.scala-lang.modules" %% "scala-xml" % "2.0.1" */
/* dependencyOverrides += "org.scala-lang.modules" %% "scala-xml" % "2.0.1" */

/* libraryDependencies += "com.lihaoyi" %% "ammonite" % "2.5.4" cross CrossVersion.full */
/* dependencyOverrides += "com.lihaoyi" %% "ammonite" % "2.5.4" cross CrossVersion.full */

libraryDependencies += "ch.epfl.scala" % "sbt-bloop_2.12_1.0" % "1.5.3"
dependencyOverrides += "ch.epfl.scala" % "sbt-bloop_2.12_1.0" % "1.5.3"

libraryDependencies += "ch.epfl.scala" % "scalafix-interfaces" % "0.10.3"
dependencyOverrides += "ch.epfl.scala" % "scalafix-interfaces" % "0.10.3"

addSbtPlugin("ch.epfl.scala" %% "sbt-scalafix" % "0.10.3")
addSbtPlugin("ch.epfl.scala" %% "sbt-bloop" % "1.5.3")

addDependencyTreePlugin

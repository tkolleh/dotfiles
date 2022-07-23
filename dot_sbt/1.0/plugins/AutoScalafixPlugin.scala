import sbt._
import Keys._
import scalafix.sbt.ScalafixPlugin
import scalafix.sbt.ScalafixPlugin.autoImport._

object AutoScalafixPlugin extends AutoPlugin {
  override def trigger = allRequirements
  override def requires = ScalafixPlugin

  override def projectSettings = Seq(
    scalacOptions += "-Ywarn-unused-import", // you might have to set this one at the config level, not sure
    semanticdbEnabled := true,
    scalafixOnCompile := false,
    semanticdbVersion := scalafixSemanticdb.revision,
  )
}
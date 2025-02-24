import sbt._
import Keys._

object ShellPrompt extends AutoPlugin {
  override def trigger = allRequirements

  override def projectSettings = Seq(
    shellPrompt := { state =>
      " (%s)> ".format(Project.extract(state).currentProject.id) }
  )
}

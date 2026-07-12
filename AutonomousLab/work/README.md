# Project workspaces

Create one directory per approved project or bounded subproject. Begin from
`templates/PROJECT_CHARTER.md` and keep project-specific theorem targets,
experiments, source audits, red-team reports, and release artifacts together.

Do not use `work/` as a second source tree. Lean code remains under `PhysicsSM/`,
manuscripts under `Sources/`, and run/proof artifacts under `AgentTasks/` when
repository conventions require them. Workspaces point to those canonical
artifacts.

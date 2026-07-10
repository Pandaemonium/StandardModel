# Codex proof job: bounded-momentum many-step convergence

Close every proof in `UniformBox/Core.lean` without changing definitions,
statements, constants, or assumptions. This is the algebraic uniformization
step for the landed fixed-momentum estimate `D(k,m)t^2/n`: prove one explicit
constant on the box `|k| <= K`, `|m| <= M`, and retain the nonzero rational
control. Do not claim a position-space propagator, PDE limit, or unbounded
momentum theorem.

Run `lake env lean UniformBox/Core.lean`. Return the complete file and a short
report of any statement issue or added helper lemma.

Project: `405dc47e-4111-4c22-8058-81be695a8b3a`  
Status at launch: RUNNING  
Submission: `AgentTasks/aristotle-submit/codex-uniform-box-many-step-20260710-01-project`

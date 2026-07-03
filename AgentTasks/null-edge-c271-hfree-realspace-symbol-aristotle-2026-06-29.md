# Aristotle task C271: Hfree real-space symbol theorem  Date: 2026-06-29  Purpose:  ```text Extend the checked real-space Kfree finite operator to the Hermitian Hfree layer and prove its Fourier symbol theorem against TetraScalarWilsonSymbol.H. ```  Prompt:  ```text AgentTasks/aristotle-prompts/gate-c1-c271-hfree-realspace-symbol.prompt.md ```  Submission project:  ```text AgentTasks/aristotle-submit/gate-c1-c271-hfree-realspace-symbol-project ```  Status:  ```text submitted / queued ```  Aristotle metadata:  ```yaml aristotle:   project_id: 81737d0b-c874-45cf-9490-8e85449e1ecd   task_id: 1cd2d8a7-ac58-4576-b680-97370a57dc31   target_file: PhysicsSM/Draft/NullEdge/GateC1/TetraFreeOperator.lean   expected_module: PhysicsSM.Draft.NullEdge.GateC1.TetraFreeOperator   submission_project: AgentTasks/aristotle-submit/gate-c1-c271-hfree-realspace-symbol-project   output_dir: AgentTasks/aristotle-output/81737d0b-c874-45cf-9490-8e85449e1ecd   status: submitted ```  Submission note:  ```text Submitted as a non-gating follow-up after local Lean progress on Kfree, OverlapIndex, TetraBranchWilsonSymbol, and OverlapLocalityCertificates. SpherePacking remote patch was disabled in the submission package. The CLI warned that the slim packet contains Lean files but no .lake directory; acceptable for these focused/non-gating jobs. ``` 

Local progress note:

```text
While C271 was running, Codex added Hfree and proved fourierUnitary_Hfree_trig locally in PhysicsSM/Draft/NullEdge/GateC1/TetraFreeOperator.lean. The targeted module build passed. Treat the Aristotle result as an audit or possible proof cleanup, not as a gating implementation dependency.
```

Integration note:

```text
Integrated C271 selectively. The live file already had Hfree and fourierUnitary_Hfree_trig, so only the useful helper theorem fourierUnitary_matrixFieldAction_Kfree_trig was added, and the Hfree theorem was simplified to use it. Verified with lake build PhysicsSM.Draft.NullEdge.GateC1.TetraFreeOperator.
```

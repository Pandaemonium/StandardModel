"""Rebuild and axiom-check the Null-Edge headline targets and numerical oracles.

The default run builds the publication-critical Lean modules and executes both
deterministic numerical validations. Pass ``--full-build`` in a clean checkout
to prepend the complete repository build required for an archival release.

Outputs are written under the selected directory as plain logs plus a JSON
summary containing source identity, normalized commands, return codes, coverage,
tool versions, and asserted SHA-256 hashes. Timing stays in console/log metadata
and is deliberately excluded from the deterministic summary.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
import sys
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
DEFAULT_OUTPUT = ROOT / "artifact" / "paper-a-verification"

HEADLINE_MODULES = (
    "PhysicsSM.Draft.NullEdge.PluckerMassDynamics",
    "PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass",
    "PhysicsSM.Draft.NullEdge.PlueckerMassOperator",
    "PhysicsSM.Draft.NullEdge.CarrierRigidity",
    "PhysicsSM.Draft.NullEdge.FourChannelRigidityCapstone",
    "PhysicsSM.Draft.NullEdge.FullBlochZeroClassification",
    "PhysicsSM.Draft.NullEdge.CommutatorWilsonStrictnessKill",
    "PhysicsSM.Draft.NullEdge.LaurentUnitResource",
    "PhysicsSM.Draft.NullEdge.LaurentFlowIndex",
    "PhysicsSM.Draft.NullEdge.LaurentFourierWalkBridge",
    "PhysicsSM.Draft.NullEdge.Goal3MarginalLine",
    "PhysicsSM.Draft.NullEdge.FiniteHomogeneousScaleNoGo",
    "PhysicsSM.Draft.NullEdge.PlueckerWindingDerived",
    "PhysicsSM.Draft.NullEdge.PlueckerPhaseObservable",
    "PhysicsSM.Draft.NullEdge.PlueckerPhaseDefectSpectrum",
    "PhysicsSM.Draft.NullEdge.PlueckerPairKickNonQuasiFree",
    "PhysicsSM.Draft.NullEdge.PlueckerQuarticNotOneBody",
    "PhysicsSM.Draft.NullEdge.PlueckerCausalCone",
    "PhysicsSM.Draft.NullEdge.PlueckerGeometricCone",
    "PhysicsSM.Draft.NullEdge.PlueckerLayerCone",
    "PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization",
    "PhysicsSM.Draft.NullEdge.CARAnnihilationLocality",
    "PhysicsSM.Draft.NullEdge.ChangingModeEmbedding",
    "PhysicsSM.Draft.NullEdge.SobolevTailRate",
    "PhysicsSM.Draft.NullEdge.Compact3Plus1RefinedWindowRate",
    "PhysicsSM.Draft.NullEdge.Compact3Plus1GrowingWindowRate",
    "PhysicsSM.Draft.NullEdge.ChannelShearModuli",
    "PhysicsSM.Draft.NullEdge.ChannelRefinementTorsor",
    "PhysicsSM.Draft.NullEdge.ChannelSelectorUniqueness",
    "PhysicsSM.Draft.NullEdge.ChannelNaturalityNoGo",
    "PhysicsSM.Draft.NullEdge.ChannelSelectorRigidity",
    "PhysicsSM.Draft.NullEdge.ChannelSelectorDescent",
    "PhysicsSM.Draft.NullEdge.ChannelPhysicalCohomology",
    "PhysicsSM.Draft.NullEdge.Carrier.WardPhysicalCohomology",
    "PhysicsSM.Draft.NullEdge.Carrier.PhysicalHomotopyLocality",
    "PhysicsSM.Draft.NullEdge.Carrier.WardAutomorphismQuotient",
    "PhysicsSM.Draft.NullEdge.Carrier.WardQuotientFactorization",
    "PhysicsSM.Draft.NullEdge.ChannelSolderDegreeNoGo",
    "PhysicsSM.Draft.NullEdge.ChannelTraceSelectorNoGo",
    "PhysicsSM.Draft.NullEdge.ChannelQuadraticSelectorFamily",
    "PhysicsSM.Draft.NullEdge.ChannelKreinMetricNoGo",
    "PhysicsSM.Draft.NullEdge.ChannelCommutatorSelectorClassification",
    "PhysicsSM.Draft.NullEdge.ChannelQuadraticInnerLift",
    "PhysicsSM.Draft.NullEdge.HalfWindingFieldPositionClassification",
    "PhysicsSM.Draft.NullEdge.ChannelKreinSectorSignature",
    "PhysicsSM.Draft.NullEdge.ChannelPositiveSectorModuli",
    "PhysicsSM.Draft.NullEdge.ChannelPositiveComplementDisk",
    "PhysicsSM.Draft.NullEdge.ChannelSelectorQuotient",
    "PhysicsSM.Draft.NullEdge.ChiralFlipMode",
    "PhysicsSM.Draft.NullEdge.SignWallDefectRouteB",
    "PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding",
    "PhysicsSM.Draft.NullEdge.HalfWindingFullWalkControls",
    "PhysicsSM.Draft.NullEdge.WallModeWitness",
    "PhysicsSM.Draft.NullEdge.Finite3Plus1ProductDFTCore",
    "PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge",
    "PhysicsSM.Draft.NullEdge.Finite3Plus1AnalyticSignBridge",
    "PhysicsSM.Draft.NullEdge.LiveDFTComposition",
    "PhysicsSM.Draft.NullEdge.OvernightTheoryAxiomGuard",
)

EXPECTED_BENCHMARK_SHA256 = (
    "dd44f1230a9d89f2d701858ea934d560fb435b9d1501edfa1ccec44e79f321b2"
)
EXPECTED_DYNAMICS_SHA256 = (
    "79cff2a9cc7e4e03a2bdefb1974849adf2163d663c54c0668c34e82884617014"
)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def git_value(*args: str) -> str:
    result = subprocess.run(
        ["git", *args], cwd=ROOT, check=False, capture_output=True, text=True
    )
    return result.stdout.strip() if result.returncode == 0 else "unavailable"


def run_check(name: str, command: list[str], output_dir: Path) -> dict[str, Any]:
    try:
        result = subprocess.run(
            command,
            cwd=ROOT,
            check=False,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
        )
        return_code = result.returncode
        stdout = result.stdout
        stderr = result.stderr
    except OSError as error:
        return_code = 127
        stdout = ""
        stderr = f"{type(error).__name__}: {error}"
    log_path = output_dir / f"{name}.log"
    log_path.write_text(
        "$ " + " ".join(command) + "\n\n"
        + stdout
        + ("\n[stderr]\n" + stderr if stderr else ""),
        encoding="utf-8",
        newline="\n",
    )
    normalized_command = []
    for argument in command:
        normalized = argument.replace(str(ROOT), "<repo>")
        if Path(argument) == Path(sys.executable):
            normalized = "python"
        normalized_command.append(normalized.replace("\\", "/"))
    return {
        "name": name,
        "command": normalized_command,
        "return_code": return_code,
        "log": str(log_path.relative_to(ROOT)).replace("\\", "/"),
        "passed": return_code == 0,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=DEFAULT_OUTPUT,
        help="Directory for logs and summary.json (default: artifact/paper-a-verification)",
    )
    parser.add_argument(
        "--full-build",
        action="store_true",
        help="Run lake build before the publication-critical targeted build.",
    )
    args = parser.parse_args()

    output_dir = args.output_dir
    if not output_dir.is_absolute():
        output_dir = ROOT / output_dir
    output_dir.mkdir(parents=True, exist_ok=True)

    python = sys.executable
    commands: list[tuple[str, list[str]]] = []
    if args.full_build:
        commands.append(("lean_full_build", ["lake", "build"]))
    commands.extend(
        [
            ("lean_headline_build", ["lake", "build", *HEADLINE_MODULES]),
            (
                "regulator_benchmark",
                [
                    python,
                    "Scripts/sim/null_edge_regulator_benchmark.py",
                    "--output",
                    str(output_dir / "null_edge_regulator_benchmark.json"),
                ],
            ),
            (
                "carrier_dynamics_harness",
                [
                    python,
                    "Scripts/oracle/carrier_dynamics_harness.py",
                    "--output",
                    str(output_dir / "carrier_dynamics_harness.json"),
                ],
            ),
        ]
    )

    checks = [run_check(name, command, output_dir) for name, command in commands]
    benchmark_path = output_dir / "null_edge_regulator_benchmark.json"
    dynamics_path = output_dir / "carrier_dynamics_harness.json"
    benchmark_sha256 = sha256(benchmark_path) if benchmark_path.exists() else None
    dynamics_sha256 = sha256(dynamics_path) if dynamics_path.exists() else None
    fixture_checks = {
        "benchmark": {
            "actual_sha256": benchmark_sha256,
            "expected_sha256": EXPECTED_BENCHMARK_SHA256,
            "passed": benchmark_sha256 == EXPECTED_BENCHMARK_SHA256,
        },
        "dynamics": {
            "actual_sha256": dynamics_sha256,
            "expected_sha256": EXPECTED_DYNAMICS_SHA256,
            "passed": dynamics_sha256 == EXPECTED_DYNAMICS_SHA256,
        },
    }
    try:
        import numpy

        numpy_version = numpy.__version__
    except ImportError:
        numpy_version = "unavailable"
    git_status = git_value("status", "--porcelain")
    summary = {
        "schema_version": 2,
        "repository": "https://github.com/Pandaemonium/StandardModel",
        "git_commit": git_value("rev-parse", "HEAD"),
        "git_status_porcelain": git_status,
        "source_tree_clean": git_status == "",
        "python_version": ".".join(map(str, sys.version_info[:3])),
        "numpy_version": numpy_version,
        "lean_toolchain": (ROOT / "lean-toolchain").read_text(encoding="utf-8").strip(),
        "lake_manifest_sha256": sha256(ROOT / "lake-manifest.json"),
        "headline_modules": list(HEADLINE_MODULES),
        "full_build_requested": args.full_build,
        "checks": checks,
        "fixture_checks": fixture_checks,
        "passed": all(check["passed"] for check in checks)
        and all(check["passed"] for check in fixture_checks.values()),
        "archival_ready": False,
    }
    summary["archival_ready"] = (
        summary["passed"] and summary["source_tree_clean"] and args.full_build
    )
    summary_path = output_dir / "summary.json"
    summary_path.write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
        newline="\n",
    )
    print(json.dumps({"passed": summary["passed"], "summary": str(summary_path)}, indent=2))
    return 0 if summary["passed"] else 1


if __name__ == "__main__":
    raise SystemExit(main())

"""Exact flat 4D calibration for buffered Alexandrov evaluation cores.

The causal-order experiments use fourth roots of Alexandrov four-volume as
their length variables. In flat four-dimensional Minkowski space this volume
radius differs from proper time by ``(pi / 24)**(1/4)``. This module records
that conversion, the exact two-sided protected-core fraction, and the balanced
count schedule used by Stage A3f-R1.

This is an external analytic calculator, not an order reconstruction theorem or
a continuum-gravity result.
"""

from __future__ import annotations

import argparse
import json
import math
from dataclasses import asdict, dataclass
from pathlib import Path


ALEXANDROV_VOLUME_COEFFICIENT_4D = math.pi / 24.0
REFERENCE_OUTER_COUNT = 8192.0
REFERENCE_BUFFER_COUNT = 32.0
REFERENCE_LOCAL_COUNT = math.sqrt(32.0)


def volume_radius_from_proper_time(proper_time: float) -> float:
    """Return ``V_4(tau)**(1/4)`` for a flat 4D Alexandrov interval."""

    if proper_time < 0.0:
        raise ValueError("proper time must be nonnegative")
    return ALEXANDROV_VOLUME_COEFFICIENT_4D**0.25 * proper_time


def proper_time_from_volume_radius(volume_radius: float) -> float:
    """Invert :func:`volume_radius_from_proper_time`."""

    if volume_radius < 0.0:
        raise ValueError("volume radius must be nonnegative")
    return volume_radius / ALEXANDROV_VOLUME_COEFFICIENT_4D**0.25


def protected_core_fraction_4d_from_z(z: float) -> float:
    """Exact two-sided depth-core fraction for ``z = 2s/T``.

    Here ``T`` is the outer proper duration and ``s`` is the required proper
    depth from each endpoint. The same dimensionless ``z`` is obtained from
    their Alexandrov volume radii, so the factor ``pi / 24`` cancels.
    """

    if not math.isfinite(z):
        raise ValueError("z must be finite")
    if z <= 0.0:
        return 1.0
    if z >= 1.0:
        return 0.0
    root = math.sqrt(1.0 - z * z)
    value = 0.5 * (
        (2.0 - 5.0 * z * z) * root
        + 3.0 * z**4 * math.acosh(1.0 / z)
    )
    return min(1.0, max(0.0, value))


def protected_core_fraction_4d(
    outer_volume_radius: float,
    buffer_volume_radius: float,
) -> float:
    """Protected-core fraction from outer and one-sided volume radii."""

    if outer_volume_radius <= 0.0:
        raise ValueError("outer volume radius must be positive")
    if buffer_volume_radius < 0.0:
        raise ValueError("buffer volume radius must be nonnegative")
    return protected_core_fraction_4d_from_z(
        2.0 * buffer_volume_radius / outer_volume_radius
    )


def expected_protected_core_count(
    outer_count: float,
    buffer_count: float,
) -> float:
    """Continuum expected protected-core count from expected count scales."""

    if outer_count <= 0.0:
        raise ValueError("outer count must be positive")
    if buffer_count < 0.0:
        raise ValueError("buffer count must be nonnegative")
    z = 2.0 * (buffer_count / outer_count) ** 0.25
    return outer_count * protected_core_fraction_4d_from_z(z)


def shifted_subdiamond_lower_bound_count(
    outer_count: float,
    buffer_count: float,
) -> float:
    """Expected count of the centered shifted subdiamond.

    This subdiamond is contained in the full protected core. Its count was
    incorrectly identified with the entire protected core in the invalidated
    first Stage A3f preregistration.
    """

    if outer_count <= 0.0:
        raise ValueError("outer count must be positive")
    if buffer_count < 0.0:
        raise ValueError("buffer count must be nonnegative")
    remaining_radius = outer_count**0.25 - 2.0 * buffer_count**0.25
    return max(0.0, remaining_radius) ** 4


def outer_count_for_expected_core(
    buffer_count: float,
    target_core_count: float,
) -> float:
    """Invert the exact protected-core expectation by monotone bisection."""

    if buffer_count < 0.0:
        raise ValueError("buffer count must be nonnegative")
    if target_core_count <= 0.0:
        raise ValueError("target core count must be positive")
    if buffer_count == 0.0:
        return target_core_count

    lower = 16.0 * buffer_count
    upper = max(2.0 * lower, target_core_count + lower)
    while expected_protected_core_count(upper, buffer_count) < target_core_count:
        upper *= 2.0
    for _ in range(100):
        midpoint = 0.5 * (lower + upper)
        if expected_protected_core_count(midpoint, buffer_count) < target_core_count:
            lower = midpoint
        else:
            upper = midpoint
    return 0.5 * (lower + upper)


def outer_to_buffer_count_ratio_for_fraction(target_fraction: float) -> float:
    """Return ``M/H`` giving the requested exact protected-core fraction."""

    if not 0.0 < target_fraction < 1.0:
        raise ValueError("target fraction must lie strictly between zero and one")
    lower_z = 0.0
    upper_z = 1.0
    for _ in range(100):
        midpoint = 0.5 * (lower_z + upper_z)
        if protected_core_fraction_4d_from_z(midpoint) > target_fraction:
            lower_z = midpoint
        else:
            upper_z = midpoint
    z = 0.5 * (lower_z + upper_z)
    return (2.0 / z) ** 4


@dataclass(frozen=True)
class BalancedCountSchedule:
    """Expected counts and finite hierarchy diagnostics at one density."""

    outer_count: float
    buffer_count: float
    local_count: float
    local_to_discreteness_radius: float
    buffer_to_local_radius: float
    outer_to_buffer_radius: float
    protected_core_fraction: float
    protected_core_count: float


def balanced_count_schedule(outer_count: float) -> BalancedCountSchedule:
    """Balanced ``ell^(1/4), ell^(1/2), ell^(3/4)`` count schedule.

    Relative to the reference outer count, the buffer and local counts scale
    with powers ``2/3`` and ``1/3``. Equivalently, under fixed-volume density
    refinement they scale as ``N^(1/2)`` and ``N^(1/4)`` while the outer count
    scales as ``N^(3/4)``.
    """

    if outer_count <= 0.0:
        raise ValueError("outer count must be positive")
    relative = outer_count / REFERENCE_OUTER_COUNT
    buffer_count = REFERENCE_BUFFER_COUNT * relative ** (2.0 / 3.0)
    local_count = REFERENCE_LOCAL_COUNT * relative ** (1.0 / 3.0)
    core_count = expected_protected_core_count(outer_count, buffer_count)
    return BalancedCountSchedule(
        outer_count=outer_count,
        buffer_count=buffer_count,
        local_count=local_count,
        local_to_discreteness_radius=local_count**0.25,
        buffer_to_local_radius=(buffer_count / local_count) ** 0.25,
        outer_to_buffer_radius=(outer_count / buffer_count) ** 0.25,
        protected_core_fraction=core_count / outer_count,
        protected_core_count=core_count,
    )


def schedule_at_density(
    events: float,
    base_events: float = 4800.0,
    base_outer_count: float = 2048.0,
) -> BalancedCountSchedule:
    """Evaluate the balanced schedule at fixed global four-volume."""

    if events <= 0.0 or base_events <= 0.0:
        raise ValueError("event counts must be positive")
    if base_outer_count <= 0.0:
        raise ValueError("base outer count must be positive")
    outer_count = base_outer_count * (events / base_events) ** 0.75
    return balanced_count_schedule(outer_count)


def independent_coverage_baseline(
    core_probability: float,
    atlas_size: int,
) -> tuple[float, float]:
    """Independent-placement coverage and repeated-given-covered baselines."""

    if not 0.0 <= core_probability <= 1.0:
        raise ValueError("core probability must lie in [0,1]")
    if atlas_size <= 0:
        raise ValueError("atlas size must be positive")
    uncovered = (1.0 - core_probability) ** atlas_size
    covered = 1.0 - uncovered
    if covered == 0.0:
        return 0.0, 0.0
    exactly_one = (
        atlas_size
        * core_probability
        * (1.0 - core_probability) ** (atlas_size - 1)
    )
    return covered, (covered - exactly_one) / covered


def analytic_report() -> dict[str, object]:
    """Return the frozen normalization audit and A3f-R1 schedule."""

    invalidated_targets = []
    for buffer_count in (4.0, 8.0, 16.0, 32.0):
        old_outer = (
            2.0 * buffer_count**0.25 + 64.0**0.25
        ) ** 4
        exact_outer = outer_count_for_expected_core(buffer_count, 64.0)
        invalidated_targets.append(
            {
                "buffer_count": buffer_count,
                "old_outer_count": old_outer,
                "old_shifted_subdiamond_count": shifted_subdiamond_lower_bound_count(
                    old_outer, buffer_count
                ),
                "old_exact_core_count": expected_protected_core_count(
                    old_outer, buffer_count
                ),
                "corrected_outer_count_for_exact_core_64": exact_outer,
            }
        )

    ell = 0.10219728214404318
    operator_volume_radius = 0.18
    a3e = []
    for buffer_ratio in (24.0, 32.0):
        buffer_count = buffer_ratio * (operator_volume_radius / ell) ** 4
        a3e.append(
            {
                "buffer_ratio": buffer_ratio,
                "one_sided_buffer_count": buffer_count,
                "ideal_global_core_fraction": (
                    expected_protected_core_count(9600.0, buffer_count)
                    / 9600.0
                ),
            }
        )

    schedules = []
    for events in (4800.0, 9600.0):
        schedule = schedule_at_density(events)
        rungs = []
        for beta in (0.8, 1.0, 1.25):
            buffer_count = beta**4 * schedule.buffer_count
            core_count = expected_protected_core_count(
                schedule.outer_count, buffer_count
            )
            covered, repeated = independent_coverage_baseline(
                core_count / events, 16
            )
            rungs.append(
                {
                    "buffer_radius_multiplier": beta,
                    "buffer_count": buffer_count,
                    "core_fraction_of_outer": core_count / schedule.outer_count,
                    "expected_core_count": core_count,
                    "independent_all_event_coverage": covered,
                    "independent_repeated_given_covered": repeated,
                }
            )
        schedules.append(
            {
                "events": events,
                "schedule": asdict(schedule),
                "buffer_rungs": rungs,
            }
        )

    return {
        "claim_boundary": (
            "external flat-4D calibration; not order reconstruction or GR"
        ),
        "alexandrov_volume_coefficient_4d": ALEXANDROV_VOLUME_COEFFICIENT_4D,
        "volume_radius_per_unit_proper_time": (
            ALEXANDROV_VOLUME_COEFFICIENT_4D**0.25
        ),
        "invalidated_a3f_targets": invalidated_targets,
        "a3e_normalization_correction": a3e,
        "a3f_r1_schedules": schedules,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    payload = analytic_report()
    rendered = json.dumps(payload, indent=2, sort_keys=True)
    if args.output is None:
        print(rendered)
    else:
        args.output.write_text(rendered + "\n", encoding="utf-8", newline="\n")


if __name__ == "__main__":
    main()

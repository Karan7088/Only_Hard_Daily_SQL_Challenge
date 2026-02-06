# Day 1: Cohort Retention Analysis with MoM Changes

**Date**: 2026-02-03  
**Difficulty**: Hard  
**Topics**: Window Functions, CTEs, Date Arithmetic

## Problem

Calculate monthly retention rates for customer cohorts with month-over-month changes.

## Rules

- First order date (any status) = cohort assignment
- Only COMPLETED orders count as active
- Retention = % of cohort with completed orders in that month
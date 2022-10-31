//
#if defined(__INTEL_COMPILER)
#include <mkl.h>
#else
#include <cblas.h>
#endif

//
#include "types.h"

//Baseline - naive implementation
f64 reduc_base(f64 *restrict a, u64 n)
{
  double d = 0.0;
  
  for (u64 i = 0; i < n; i++)
    d += a[i];

  return d;
}

// Unroll the loop with a factor of 4
f64 reduc_unroll4 (f64 *restrict a, u64 n)
{
  #define UNROLL4 4

  double d = 0.0;
  u64 i = 0;

  for (i = 0; i < n - UNROLL4; i += UNROLL4) {
    d += a[i];
    d += a[i+1];
    d += a[i+2];
    d += a[i+3];
  }

  while(i < n) {
    d += a[i];
    i++;
  }

  return d;
}

// Unroll the loop with a factor of 8
f64 reduc_unroll8 (f64 *restrict a, u64 n)
{
  #define UNROLL8 8

  double d = 0.0;
  u64 i = 0;

  for (i = 0; i < n - UNROLL8; i += UNROLL8) {
    d += a[i];
    d += a[i+1];
    d += a[i+2];
    d += a[i+3];
    d += a[i+4];
    d += a[i+5];
    d += a[i+6];
    d += a[i+7];
  }

  while(i < n) {
    d += a[i];
    i++;
  }

  return d;
}

// Unroll the loop with a factor of 16 
f64 reduc_unroll16 (f64 *restrict a, u64 n)
{
  #define UNROLL16 16 

  double d = 0.0;
  u64 i = 0;

  for (i = 0; i < n - UNROLL16; i += UNROLL16) {
    d += a[i];
    d += a[i+1];
    d += a[i+2];
    d += a[i+3];
    d += a[i+4];
    d += a[i+5];
    d += a[i+6];
    d += a[i+7];
    d += a[i+8];
    d += a[i+9];
    d += a[i+10];
    d += a[i+11];
    d += a[i+12];
    d += a[i+13];
    d += a[i+14];
    d += a[i+15];
  }

  while(i < n) {
    d += a[i];
    i++;
  }

  return d;
}

// Cblas implementation of double precision 1-norm (as all our elements are positive it is the same as a reduc)
f64 reduc_cblas(f64 *restrict a, u64 n) {

    return cblas_dasum(n, a, 1);

}


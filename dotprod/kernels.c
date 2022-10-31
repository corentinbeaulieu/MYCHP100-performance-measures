//
#if defined(__INTEL_COMPILER)
#include <mkl.h>
#else
#include <cblas.h>
#endif

//
#include "types.h"

//Baseline - naive implementation
f64 dotprod_base(f64 *restrict a, f64 *restrict b, u64 n)
{
  double d = 0.0;
  
  for (u64 i = 0; i < n; i++)
    d += a[i] * b[i];

  return d;
}

// Loop unroll with an unroll factor of 4
f64 dotprod_unroll4(f64 *restrict a, f64 *restrict b, u64 n) {

  #define UNROLL4 4

  double d = 0.0;
  const u64 endFor = n - UNROLL4;
  u64 i;

  for(i = 0; i < endFor; i += UNROLL4) {

      d += a[i]     * b[i];
      d += a[i + 1] * b[i + 1];
      d += a[i + 2] * b[i + 2];
      d += a[i + 3] * b[i + 3];
  }

  while(i < n) {
    d += a[i]     * b[i];
    i++;
  }

  return d;
}

// Loop unroll with an unroll factor of 8
f64 dotprod_unroll8(f64 *restrict a, f64 *restrict b, u64 n) {

  #define UNROLL8 8

  double d = 0.0;
  const u64 endFor = n - UNROLL8;
  u64 i;

  for(i = 0; i < endFor; i += UNROLL8) {

      d += a[i]     * b[i];
      d += a[i + 1] * b[i + 1];
      d += a[i + 2] * b[i + 2];
      d += a[i + 3] * b[i + 3];
      d += a[i + 4] * b[i + 4];
      d += a[i + 5] * b[i + 5];
      d += a[i + 6] * b[i + 6];
      d += a[i + 7] * b[i + 7];
  }

  while(i < n) {
    d += a[i]     * b[i];
    i++;
  }

  return d;
}

 // Loop unroll with an unroll factor of 16 
f64 dotprod_unroll16(f64 *restrict a, f64 *restrict b, u64 n) {

  #define UNROLL16 16 

  double d = 0.0;
  const u64 endFor = n - UNROLL16;
  u64 i;

  for(i = 0; i < endFor; i += UNROLL16) {

      d += a[i]      * b[i];
      d += a[i + 1]  * b[i + 1];
      d += a[i + 2]  * b[i + 2];
      d += a[i + 3]  * b[i + 3];
      d += a[i + 4]  * b[i + 4];
      d += a[i + 5]  * b[i + 5];
      d += a[i + 6]  * b[i + 6];
      d += a[i + 7]  * b[i + 7];
      d += a[i + 8]  * b[i + 8];
      d += a[i + 9]  * b[i + 9];
      d += a[i + 10] * b[i + 10];
      d += a[i + 11] * b[i + 11];
      d += a[i + 12] * b[i + 12];
      d += a[i + 13] * b[i + 13];
      d += a[i + 14] * b[i + 14];
      d += a[i + 15] * b[i + 15];
  }

  while(i < n) {
    d += a[i]     * b[i];
    i++;
  }

  return d;
}

// Cblas implementation of the double precision dotprod
f64 dotprod_cblas(f64 *restrict a, f64 *restrict b, u64 n) {

    return cblas_ddot(n, a, 1, b, 1);
}
    

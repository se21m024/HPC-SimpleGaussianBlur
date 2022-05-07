/*
* a kernel that applies the gaussian blur to a bitmap
*/
__kernel void blur(
    __global uchar4 *pixels,
    __global uchar4 *out,
    __global double* ckernel,
    __constant int *rows,
    __constant int *cols,
    __constant int *cKernelDimension)
{   
    int idx = get_global_id(0);
    int currentRow = idx / (*cols);
    int currentCol = idx % (*cols);
    double4 acc= (double4)(0.0);
 
    //printf("%d, %d, %d\n", idx, currentRow, currentCol);

    //printf("In:  %d, %d, %d\n", (pixels)[idx].s0, (pixels)[idx].s1, (pixels)[idx].s2);

    /*
    if(idx == 0)
    {
        printf("rows: %d\n", *rows);
        printf("cols: %d\n", *cols);
        printf("cKernelDimension: %d\n", *cKernelDimension);

        printf("Kernel Matrix:\n");
        int kd;
        for(kd = 0; kd < (*cKernelDimension)*(*cKernelDimension); kd++)
        {
            printf("%f\n", ckernel[kd]);
        }
    }
    */

    int i, j;
         
    for(j = 0; j < (*cKernelDimension); j++)
    {
        int y = currentRow + (j - (*cKernelDimension / 2));
        if(y < 0 || y >= *rows) y = currentRow;
         
        for(i = 0; i < (*cKernelDimension); i++)
        {
            int x = currentCol + (i - (*cKernelDimension / 2));
            if(x < 0 || x >= *cols)
            {
                x = currentCol;
            }
             
            acc +=  convert_double4( (pixels[((y * (*cols) + x))])) * ckernel[(j * (*cKernelDimension)) + i];
        }
    }

    //printf("Out: %f, %f, %f\n", acc.s0, acc.s1, acc.s2);

    //converts to uchar4 and clamps result to range [0,255]
    out[idx] = convert_uchar4_sat(acc);
    
    //printf("%d, %d, %d\n", out[idx].s0, out[idx].s1, out[idx].s2);
}
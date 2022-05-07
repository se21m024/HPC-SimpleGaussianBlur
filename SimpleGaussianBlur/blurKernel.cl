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

    //converts to uchar4 and clamps result to range [0,255]
    out[idx] = convert_uchar4_sat(acc);
}
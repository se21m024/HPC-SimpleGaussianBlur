/*
* a kernel that applies the gaussian blur to a bitmap
*/
__kernel void blur(
    __global uchar4 *inputPixels,
    __global uchar4 *outputPixels,
    __global double *cKernel,
    __constant int *rows,
    __constant int *cols,
    __constant int *cKernelDimension)
{
    int idx = get_global_id(0);
    int currentRow = idx / (*cols);
    int currentCol = idx % (*cols);
    double4 tempPixel = (double4)(0.0);

    int i, j;

    for(j = 0; j < (*cKernelDimension); j++)
    {
        int y = currentRow + (j - (*cKernelDimension / 2));
        if(y < 0 || y >= *rows)
        {
            y = currentRow;
        }

        for(i = 0; i < (*cKernelDimension); i++)
        {
            int x = currentCol + (i - (*cKernelDimension / 2));
            if(x < 0 || x >= *cols)
            {
                x = currentCol;
            }

            tempPixel +=  convert_double4( (inputPixels[((y * (*cols) + x))])) * cKernel[(j * (*cKernelDimension)) + i];
        }
    }

    // convert to uchar4 and adjust value
    outputPixels[idx] = convert_uchar4_sat(tempPixel);
}
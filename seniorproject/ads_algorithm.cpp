// RADIANCE
// Algorithm to convert photodiode currents into an off-sun angle.

#include <math.h>

double off_sun_angle (double top_curr, double bottom_curr, double left_curr, double right_curr) {
	double y,z,theta_y,theta_z,sun_angle;
	double slope = 45;	// Slope of linear relationship between fraction of
						// current and that component of sun angle
	// Compute relative amount of sunlight in z and y directions
	z = (bottom_curr - top_curr) / (bottom_curr + top_curr);
	y = (left_curr - right_curr) / (left_curr + right_curr);
	// Compute angle (assuming linear relationships)
	if (z != 0) {
		sun_angle = atan(y/z) * 180/PI
	} else {
		sun_angle = y*slope;
	}
}
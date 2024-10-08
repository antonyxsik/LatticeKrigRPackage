# LatticeKrig  is a package for analysis of spatial data written for
# the R software environment .
# Copyright (C) 2016
# University Corporation for Atmospheric Research (UCAR)
# Contact: Douglas Nychka, nychka@ucar.edu,
# National Center for Atmospheric Research, PO Box 3000, Boulder, CO 80307-3000
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with the R software environment if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
# or see http://www.r-project.org/Licenses/GPL-2

LKrigNormalizeBasis <- function(LKinfo, Level, PHI=NULL, 
                                x1=NULL, 
                                gridList= NULL,...) {

  # next condition is mainly for ease of testing this outside of LKrig.basis
  if( is.null( PHI)){
    if( is.null(x1)){
      if( is.null( gridList)){
        stop(" missing location information ")
      }
      x1<- make.surface.grid( gridList)
    }
    PHI<- LKrig.basis(x1, LKinfo = LKinfo,
                raw=TRUE, Level = Level)
  }
  # get  SAR matrix at level Level
	tempB <- LKrigSAR(LKinfo, Level = Level)
	# tempB is in spind format
	tempB<- spam( tempB[c("ind", "ra")], nrow=tempB$da[1], ncol=tempB$da[2])
	# quadratic form involves applying inverse precision matrix to basis function evaluted at
	# locations for evaluation
wght <- LKrig.quadraticform(t(tempB) %*% tempB, PHI = PHI,
                     choleskyMemory = LKinfo$choleskyMemory)
	return(wght)
}


# hook for a model specific fast normalization 
LKrigNormalizeBasisFast <- function(LKinfo, ...) {
	UseMethod("LKrigNormalizeBasisFast")
}
LKrigNormalizeBasisFast.default <- function(LKinfo, ...) {
	stop("There is no default method for fast normalization")
}
# see 


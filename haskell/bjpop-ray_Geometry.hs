{-------------------------------------------------------------------------------

        Copyright:              Bernie Pope 2004

        Module:                 Geometry

        Description:            Geometric operations like scaling, rotating
                                and translating.

        Primary Authors:        Bernie Pope

-------------------------------------------------------------------------------}

module Geometry where

import Data

--------------------------------------------------------------------------------

-- translate a point in the X Y and Z
translate :: Double -> Double -> Double -> Coord -> Coord
translate tx ty tz pt
   = Coord
     { cx = px + tx
     , cy = py + ty
     , cz = pz + tz
     }
   where
   px = cx pt
   py = cy pt
   pz = cz pt

-- scale a point about the origin, by scaling factors
-- in X Y and Z
scale :: Double -> Double -> Double -> Coord -> Coord
scale sx sy sz pt
   = Coord
     { cx = px * sx
     , cy = py * sy
     , cz = pz * sz
     }
   where
   px = cx pt
   py = cy pt
   pz = cz pt

-- rotations are in degrees

-- rotate a point around the Z axis
rotateZ :: Double -> Coord -> Coord
rotateZ rz pt
   = Coord
     { cx = (px * c) - (py * s)
     , cy = (px * s) + (py * c)
     , cz = pz
     }
   where
   px = cx pt
   py = cy pt
   pz = cz pt
   c = cos radianRotate
   s = sin radianRotate
   radianRotate = (rz*2*pi)/360

-- rotate a point around the Y axis
rotateY :: Double -> Coord -> Coord
rotateY ry pt
   = Coord
     { cx = (px * c) + (pz * s)
     , cy = py
     , cz = (pz * c) - (px * s)
     }
   where
   px = cx pt
   py = cy pt
   pz = cz pt
   c = cos radianRotate
   s = sin radianRotate
   radianRotate = (ry*2*pi)/360

-- rotate a point around the X axis
rotateX :: Double -> Coord -> Coord
rotateX rx pt
   = Coord
     { cx = px
     , cy = (py * c) - (pz * s)
     , cz = (py * s) + (pz * c)
     }
   where
   px = cx pt
   py = cy pt
   pz = cz pt
   c = cos radianRotate
   s = sin radianRotate
   radianRotate = (rx*2*pi)/360


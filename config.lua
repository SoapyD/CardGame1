--application =
--{
--    content =
--    {
--        fps = 60,
-- 		width = 320,
--		height = 480,
--		scale = "letterbox" -- zoom to screen dimensions (may add extra space at top or sides)       
--    }
--}

--calculate the aspect ratio of the device
local aspectRatio = display.pixelHeight / display.pixelWidth
application = {
   content = {
      width = aspectRatio > 1.5 and 800 or math.ceil( 1200 / aspectRatio ),
      height = aspectRatio < 1.5 and 1200 or math.ceil( 800 * aspectRatio ),
      scale = "letterBox",
      fps = 60,

      imageSuffix = {
         ["@2x"] = 1.3,
      },
   },
}
Camera =
{
	left = 0;
	right = ScreenWidth;
	top = 0;
	bottom = ScreenHeight;
}
function Camera.move(x, y)
	if x and y then
		Camera.left = aMapWidth * x
		Camera.rigtht = Camera.left + ScreenWidth
		Camera.top = aMapHeight * y
		Camera.bottom = Camera.top + ScreenHeight
	end
end
function Camera.isActorInCamera(actor)
	local X = actor.x 
	local Y = actor.y
	if X >= Camera.left and X <= Camera.right and Y >= top and Y <= Camera.bottom then
	return true, aMapWidth * X , aMapHeight * Y
	else
	return false, -1, -1
	end
end

function Camera.getActorPos(actor)
	return (actor.x - Camera.left) * aMapWidth, actor.y * aMapHeight
end

function Camera.getPos(x, y)
	return (x - Camera.left) * aMapWidth, y * aMapHeight
end

function XInCamera(x)
	if x >= Camera.left and x <= Camera.right  then
		return true
	else
		return false
	end
end
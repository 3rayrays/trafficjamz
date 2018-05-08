function car = initializeCar(index,time)

initializeDesiredSpeed = @() 40 + rand * 60;
initializeFrustration = @() rand;

car(index).index = index;
car(index).desiredSpeed = initializeDesiredSpeed();
car(index).frustration = initializeFrustration();
car(index).speed = 0;
car(index).position = 0;
car(index).acceleration = 0;
car(index).time = time;
car = car(index);

end
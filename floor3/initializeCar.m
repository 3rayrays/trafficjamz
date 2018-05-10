function car = initializeCar(index,t)

initializeDesiredSpeed = @() 30 + rand * 20;
initializeFrustration = @() rand;

car(index).index = index;
car(index).desiredSpeed = initializeDesiredSpeed();
car(index).frustration = initializeFrustration();
car(index).speed = 25 + rand * 25;
car(index).position = 0;
car(index).acceleration = 0;
car(index).time = t;
car = car(index);

end
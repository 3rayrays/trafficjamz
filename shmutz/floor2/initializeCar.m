function car = initializeCar(index,t)

initializeDesiredSpeed = @() 20 + rand * 30;
initializeFrustration = @() rand;

car(index).index = index;
car(index).desiredSpeed = initializeDesiredSpeed();
car(index).frustration = initializeFrustration();
car(index).speed = 0 + rand * 10;
car(index).position = 0;
car(index).acceleration = 0;
car(index).time = t;
car = car(index);

end
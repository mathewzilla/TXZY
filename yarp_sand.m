% for playing with yarp

LoadYarp;
import yarp.BufferedPortBottle
import yarp.Port
import yarp.Bottle
import yarp.Network
import yarp.Vector
import yarp.*

localreadport = '/data/input';
remotewriteport = '/data/output';
localwriteport = '/matlab/output';
remotereadport = '/matlab/input';

outputBottle = Bottle;

inputport = BufferedPortBottle;
outputport = Port

inputport.open(localreadport);
outputport.open(localwriteport);

Network.connect(remotewriteport, localreadport);
Network.connect(localwriteport, remotereadport);

inputbottle = inputport.read(true)


x = inputbottle.get(1).asInt();

x*2

if (strcmp(inputbottle.get(0).asString(), 'test'))

outputBottle.addString('ok')
outputPort.write(outputBottle)
outputBottle.clear();

end


Network.disconnect(remotewriteport, localreadport);
inputport.close
Network.disconnect(localwriteport, remotereadport);
outputport.close
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

inputport = BufferedPortBottle;

inputport.open(localreadport);

Network.connect(remotewriteport, localreadport);

inputbottle = inputport.read(true);
inputbottle.get(0).asString();

import os
import sys


THIS_DIR = os.path.dirname(os.path.realpath(__file__))

if __name__ == "__main__":
    import sys
    from subprocess import call

    print "coffee %s" %sys.argv[1]
    print "-a"
    print "-t"
    print "-i %s" %os.path.join(THIS_DIR, "coffee")
    print "-I %s" %os.path.join(THIS_DIR, "jsonld")
    print "-o %s" %os.path.join(THIS_DIR, "jsonld")
    print "-f"
    print ""
    
    call(["coffee",
          sys.argv[1],
          #"-v",
          #"-s",
          "-a",
          "-t",
          "-i", os.path.join(THIS_DIR, "coffee"),
          "-I", os.path.join(THIS_DIR, "jsonld"),
          "-o", os.path.join(THIS_DIR, "jsonld"),
          "-f"])

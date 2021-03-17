#include <eicsmear/functions.h>

void genTree(const std::string x, const std::string y) // TString
{
  gSystem->Load("libeicsmear");
  gSystem->Load("libeicsmeardetectors");
  BuildTree(x,y);
}


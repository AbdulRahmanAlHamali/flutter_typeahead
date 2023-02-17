cd ..
echo "> # Library code # lib:"
find ./lib -name "*.dart" -type f|xargs wc -l | grep total
echo"> How the library code is distributed between files:"
find ./lib -name "*.dart" -type f|xargs wc -l
echo "> # Example:"
find ./example/lib -name "*.dart" -type f|xargs wc -l | grep main
echo "> # Should have nothing after this line, as examples are single files in pub.dev"
find ./example/lib -name "*.dart" -type f|xargs wc -l | grep total

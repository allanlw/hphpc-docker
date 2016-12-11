<?php

for ($i = 0; $i <= 15; $i++) {
  if ($i % 3 == 0) {
     echo "Fizz ";
  }
  if ($i % 5 == 0) {
    echo "Buzz ";
  }
  if ($i % 5 != 0 && $i % 3 != 0) {
    echo $i;
  }
  echo "\n";
}

?>

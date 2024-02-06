#! /usr/bin/env bash


# Tries do downlaod images from the API. Stops after 10 unsuccessful tries.

download_images()
{
      num=1
      counter=0

      while true; do
      if [[ "${counter}" == 10 ]]; then
            break
      fi
      if [[ ! -f "img${num}.jpeg"  ]]; then
           
            if ! curl -s "https://downloads.codingcoursestv.eu/055%20-%20bash/while/images/image-${num}.jpg" -o "img${num}.jpeg"  --fail; then
                  echo "Couldn't downlaod image ${num}"
                  (( counter += 1 ))
            else  
                  echo "Successfully downloaded image ${num}"
            fi
            (( num += 1))
      else
            echo " Image ${num} already exists"
            (( num += 1))
      fi
      done
}

# Creates a thumbnail for each image

create_thumbnail()
{
      for img in *.jpg *.jpeg *.png *.gif; do
            if [[ ! -f "${img}" ]]; then
                  continue
            else
                  if [[ ! -f  "${img%.*}.thumbnail.txt" ]]; then
                        identify "${img}" > "${img%.*}.thumbnail.txt"
                  fi
            fi
      done
}

# main function

main()
{
      download_images
      create_thumbnail
}

main 

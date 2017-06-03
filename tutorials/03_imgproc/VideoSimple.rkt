#! /usr/bin/env racket
;; Author: Petr Samarin
;; Date: 2012
;; Description:
;; Capture video from a camera
;; if some key is pressed while the focus is on the video window, the application terminates
#lang racket

;;; Includes
(require opencv/core
         opencv/types
         opencv/highgui
         opencv/imgproc
         opencv/videoio)

(define capture (cvCaptureFromCAM 0))

;; Reduce image resolution to 640x480
(cvSetCaptureProperty capture CV_CAP_PROP_FRAME_WIDTH 640.0)
(cvSetCaptureProperty capture CV_CAP_PROP_FRAME_HEIGHT 480.0)

;; Capture an image to get parameters
(define captured-image (cvQueryFrame capture))

;; Get parameters from the captured image to initialize
;; copied images
(define width    (IplImage-width captured-image))
(define height   (IplImage-height captured-image))
(define size     (make-CvSize width height))
(define depth    (IplImage-depth captured-image))
(define channels (IplImage-nChannels captured-image))

;; Init an IplImage to where captured images will be copied
(define frame (cvCreateImage size IPL_DEPTH_8U 1))

(let loop ()
  (set! captured-image (cvQueryFrame capture))  
  (cvShowImage "Video Simple" captured-image)
  (unless (>= (cvWaitKey 1) 0)
    (loop)))

;; clean up
(cvReleaseCapture capture)
(cvDestroyAllWindows)

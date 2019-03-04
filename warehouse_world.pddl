(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   (:action robotMove
      :parameters (?r - robot ?l1 - location ?l2 - location)
      :precondition (and (free ?r) (connected ?l1 ?l2) (at ?r ?l1) (no-robot ?l2))
      :effect (and (no-robot ?l1) (at ?r ?l2) (not (at ?r ?l1)) (not (no-robot ?l2)))
   )
   (:action pickup
      :parameters (?r - robot ?l - location ?p - pallette)
      :precondition (and (free ?r) (at ?r ?l) (at ?p ?l))
      :effect (and (has ?r ?p) (not (free ?r)))
   )
   (:action drop
      :parameters (?r - robot ?l - location ?p - pallette)
      :precondition (and (has ?r ?p) (at ?r ?l) (at ?p ?l))
      :effect (and (free ?r) (not (has ?r ?p)))
   )
   (:action robotMoveWithPallette
      :parameters (?r - robot ?l1 - location ?l2 - location ?p - pallette)
      :precondition (and (not (free ?r)) (connected ?l1 ?l2) (at ?r ?l1) (at ?p ?l1) (has ?r ?p) (no-pallette ?l2) (no-robot ?l2))
      :effect (and (at ?r ?l2) (at ?p ?l2) (no-pallette ?l1) (no-robot ?l1) (not (at ?r ?l1)) (not (at ?p ?l1)) (not (no-pallette ?l2)) (not (no-robot ?l2)))
   )
   (:action moveItemFromPalletteToShipment
      :parameters (?si - saleitem ?l - location ?s - shipment ?p - pallette ?o - order)
      :precondition (and (started ?s)(contains ?p ?si)(at ?p ?l)(packing-at ?s ?l)(packing-location ?l)(ships ?s ?o)(orders ?o ?si))
      :effect (and (not (contains ?p ?si))(includes ?s ?si))
   )
   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s)(packing-at ?s ?l)(packing-location ?l)(ships ?s ?o))
      :effect (and (complete ?s) (available ?l)(not (started ?s))(not (packing-at ?s ?l)))
   )
)
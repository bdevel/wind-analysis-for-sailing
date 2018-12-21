
linMap <- function(x, from, to)
  (x - min(x)) / max(x - min(x)) * (to - from) + from


## new vector with values shift over one.
prevValues <- function(data){
    prev = c(data[1], data[1:length(data)-1])
    return(prev)
}

## difference delta
diffDelta <- function(data){
    diffs = data - prevValues(data)
    return(diffs)
}



sma <- function(arr, n=15){
    res = arr
    for(i in n:length(arr)){
        res[i] = mean(arr[(i-n):i])
    }
    res
}

## Length of each vector in the list: lapply(fl, function(data) length(data))
splitAtTrue <- function(data, doSplit) {
    out     <- list()
    current <- c()
    
    for (i in seq_along(data) ) {
        if (doSplit[i]) {
            out[[length(out) + 1]] <- current
            current <- c(data[i])
        } else {
            current <- c(current, data[i])
        }
    }

    ## return whatever is left.. i think this needed
    out[[length(out) + 1]] <- current
    return(out)
}


# Cumsum and split, reset at each split
cumsumSplitReset <- function(data, doSplit, addZero) {
    out     <- list()
    
    if(addZero){
        current <- c(0)
    }else {
        current <- c()
    }

    for (i in seq_along(data) ) {
        if (doSplit[i]) {
            out[[length(out) + 1]] <- cumsum(current) #data[pos2[i]:(pos2[i+1]-1)]
            if(addZero){# reset
                current <- c(0, data[i])
            }else {
                current <- c(data[i])
            }
        } else {
            current <- c(current, data[i])
        }
    }
    out[[length(out) + 1]] <- cumsum(current)
    return(out)
}

resetCumSum <- function(x, doReset) {
    out     <- c()
    current <- c(0) # TODO: ADD ZERO?

    for (i in seq_along(x) ) {
        if (doReset[i]) {
            out <- c(out, cumsum(current))
            current <- c(0)# always start at zero
        } else {
            current <- c(current, x[i])
        }
    }
    out[[length(out) + 1]] <- c(out, cumsum(current))
    return(out)
}


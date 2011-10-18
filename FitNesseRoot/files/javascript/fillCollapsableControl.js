(function() {
  var finished = false;
  var $control = jQuery('<div id="collapsable_control_container" class="meta"></div>');

  addExpandCollapseAllIfExpandableSectionsExist();
  addExpandFailedScenariosIfFailedScenariosExist();
  executeAsSoonAs(hasCollapsableSections, insertCollapsableControlContainer);
  removeOldExpandCollapseAllLinks();

  jQuery(document).ready(function() {
    finished = true;
  });

  function addExpandCollapseAllIfExpandableSectionsExist() {
    executeAsSoonAs(hasCollapsableSections, function() {
      $control.append('<a href="javascript:expandAll();">Expand All</a> | <a href="javascript:collapseAll();">Collapse All</a>');
    });
  }

  function addExpandFailedScenariosIfFailedScenariosExist() {
    executeAsSoonAs(hasFailedScenarios, function() {
      // expandFailedScenarios is only available in this scope, so
      // <a href="expandFailedScenarios();">
      // does not work.
      $expandFailedScenariosLink = jQuery('<a href="#">Expand Failed Scenarios</a>');
      $expandFailedScenariosLink.click(function (event) {
        event.preventDefault();
        expandFailedScenarios();
      });
      $control.prepend(' | ').prepend($expandFailedScenariosLink);
    });
  }

  function insertCollapsableControlContainer() {
    executeAsSoonAs(hasMainbar, function() {
      jQuery(".mainbar").prepend($control);
    });
  }

  function removeOldExpandCollapseAllLinks() {
    jQuery('div.collapse_rim>div.meta').remove();
    callUnlessFinished(removeOldExpandCollapseAllLinks);
  }

  function executeAsSoonAs(condition, callback) {
    if (condition()) {
      callback();
    } else {
      callUnlessFinished(function() {
        executeAsSoonAs(condition, callback)
      });
    }
  }

  function callUnlessFinished(callback) {
    if (!finished) {
      setTimeout(callback, 300);
    }
  }

  function hasCollapsableSections() {
    return elementExists(jQuery('div.collapse_rim'));
  }

  function hasFailedScenarios() {
    return elementExists(jQuery('td.fail>div.collapse_rim'));
  }

  function hasMainbar() {
    return elementExists(jQuery(".mainbar"));
  }

  function elementExists($element) {
    return $element.size() > 0;
  }

  function expandFailedScenarios() {
    jQuery('td.fail>div.collapse_rim>div.hidden').each(function() {
      toggleCollapsable(this.id)
    });
  }
})()

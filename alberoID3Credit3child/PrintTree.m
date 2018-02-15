function [] = PrintTree(tree, parent)

% Stampo il nodo corrente
if (strcmp(tree.value, 'true'))
    fprintf('parent: %s\ttrue\n', parent);
    return
elseif (strcmp(tree.value, 'false'))
    fprintf('parent: %s\tfalse\n', parent);
    return
else
    % Nodo e attributo utilizzato per lo split
    fprintf('parent: %s\tattribute: %s\tleftChild:%s\tcenterChild:%s\trightChild:%s\n', ...
        parent, tree.value, tree.left.value, tree.center.value, tree.right.value);
end

% Chiamata ricorsiva di sinistra
PrintTree(tree.left, tree.value);

% Chiamata ricorsiva di centro
PrintTree(tree.center, tree.value);

% Chiamata ricorsiva di destra
PrintTree(tree.right, tree.value);

end